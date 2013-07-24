class ASE
  class File < ::File
    FORMATS = {
      ulonglong: {
        length: 8,
        code: 'Q>'
      },
      longlong: {
        length: 8,
        code: 'q>'
      },
      double: {
        length: 8,
        code: 'G'
      },
      float: {
        length: 4,
        code: 'F'
      },
      uint: {
        length: 4,
        code: 'L>'
      },
      int: {
        length: 4,
        code: 'l>'
      },
      ushort: {
        length: 2,
        code: 'S>'
      },
      short: {
        length: 2,
        code: 's>'
      },
      ulong: {
        length: 4,
        code: 'L>'
      },
      long: {
        length: 4,
        code: 'l>'
      }
    }

    FORMATS.each do |format, info|
      define_method "read_#{format}" do
        read(info[:length]).unpack(info[:code])[0]
      end

      define_method "write_#{format}" do |*args|
        write args.pack(info[:code] + '*')
      end
    end

    def read_string
      length = read_ushort
      read(length * 2).encode('UTF-8', 'UTF-16BE').delete("\00")
    end

    def write_string(string)
      write_ushort(string.length + 1)
      write string.encode('UTF-16BE')
      write_null_byte
    end

    def write_null_byte
      write [0].pack('S>')
    end
  end
end