// Copyright (c) 2010, Philipp Stephani
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#include <cstddef>
#include <vector>
#include <iostream>

#include <boost/cstdint.hpp>
#include <boost/algorithm/string.hpp>
#include <boost/filesystem.hpp>
#include <boost/interprocess/file_mapping.hpp>
#include <boost/interprocess/mapped_region.hpp>


struct ttc_header {
  boost::uint32_t tag;
  boost::uint32_t version;
  boost::uint32_t num_fonts;
};

struct offset_table {
  boost::uint32_t version;
  boost::uint16_t num_tables;
  boost::uint16_t search_range;
  boost::uint16_t entry_selector;
  boost::uint16_t range_shift;
};

struct table_record {
  boost::uint32_t tag;
  boost::uint32_t checksum;
  boost::uint32_t offset;
  boost::uint32_t length;
};

struct math_header {
  boost::uint32_t version;
  boost::uint16_t constants;
  boost::uint16_t glyph_info;
  boost::uint16_t variants;
};

struct math_glyph_info {
  boost::uint16_t italics_correction_info;
  boost::uint16_t top_accent_attachment;
  boost::uint16_t extended_shape_coverage;
  boost::uint16_t kern_info;
};

struct math_top_accent_attachment {
  boost::uint16_t coverage;
  boost::uint16_t count;
};

struct coverage_table {
  boost::uint16_t format;
  boost::uint16_t count;
};

struct range_record {
  boost::uint16 start;
  boost::uint16 end;
  boost::uint16 index;
};

struct math_value_record {
  boost::int16_t value;
  boost::uint16_t device_table;
};


void analyze_file(const boost::filesystem::path& path);
void analyze_otf(const void* data, boost::uint32_t offset = 0);
void analyze_ttc(const void* data);
void analyze_table(const void* data);


int main(int argc, const char* const argv[]) {
  for (int i = 1; i < argc; ++i) {
    analyze_file(argv[i]);
  }
}

void analyze_file(const boost::filesystem::path& path) {
  std::cout << "Analyzing file " << path << '\n';
  const bool is_ttc = boost::iequals(path.extension(), ".ttc");
  const std::size_t size = boost::filesystem::file_size(path);
  const boost::interprocess::file_mapping mapping(path, boost::interprocess::read_only);
  const boost::interprocess::mapped_region<boost::interprocess::file_mapping> region(mapping, boost::interprocess::read_only, 0, size);
  if (is_ttc) {
    analyze_ttc(region.get_address());
  } else {
    analyze_otf(region.get_address());
  }
  std::cout << std::endl;
}

void analyze_otf(const void* data, boost::uint32_t offset = 0) {
  std::cout << "Analyzing OpenType font at offset " << offset << '\n';
  const offset_table* header = data + offset;
  const table_record* directory = data + offset + sizeof(offset_table);
  const boost::uint32_t math_tag = 'M' + ('A' << 8) + ('T' << 16) + ('H' << 24);
  for (boost::uint16 i = 0; i < header->num_tables; ++i) {
    const table_record* table = directory[i];
    if (table->tag == math_tag) {
      analyze_table(data + table->offset);
    }
  }
}

void analyze_ttc(const void* data) {
  std::cout << "Analyzing TrueType collection\n";
  const ttc_header* header = data;
  const boost::uint32_t* offsets = data + sizeof(header);
  for (boost::uint32_t i = 0; i < header->num_fonts; ++i) {
    analyze_otf(data, offsets[i]);
  }
}

void analyze_table(const void* data) {
  std::cout << "Analyzing MATH table\n";
  const math_header* header = data;
  if (header->glyph_info) {
    analyze_glyph_info(data + header->glyph_info);
  }
}

void analyze_glyph_info(const void* data) {
  std::cout << "Analyzing glyph information\n";
  const glyph_info* header = data;
  if (header->top_accent_attachment) {
    analyze_accent_attachment(data + header->top_accent_attachment);
  }
}

void analyze_accent_attachment(const void* data) {
  std::cout << "Analyzing top accent attachment\n";
  const top_accent_attachment* header = data;
  if (header->coverage) {
    const std::vector<boost::uint16_t> coverage = parse_coverage_table(data + header->coverage);
    if (header->count != coverage.size()) {
      std::cout << "Inconsistent count (values = " << header->count << ", coverage = " << coverage.size() << ")\n";
    }
  } else {
    std::cout << "Coverage table missing\n"
  }
}

const std::vector<boost::uint16_t> parse_coverage_table(const void* data) {
  const coverage_table* header = data;
  if (header->format == 1) {
    const boost::uint16_t* directory = data + sizeof(coverage_table);
    return std::vector<boost::uint16_t>(directory, directory + header->count);
  } else {
    const range_record* directory = data + sizeof(coverage_table);
    std::vector<boost::uint16_t> result;
    for (boost::uint16_t i = 0; i < header->count; ++i) {
      const range_record* record = directory + i;
      const boost::uint16_t count = record->end - record->start + 1;
      const boost::uint16_t size = record->index + count;
      if (result.size() < size) {
        result.resize(size);
      }
      for (boost::uint16_t j = 0; j < count; ++j) {
        result[record->index + j] = record->start + j;
      }
    }
    return result;
  }
}
