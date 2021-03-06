class FzfObcTest
  def test_insmod
    for short_filedir in (0..1).reverse_each do
      # insmod use _filedir with extension filter
      create_files_dirs(
        subdirs: %w{d1},
        files: %w{
          test.ko.gz
          test\ 1.ko.gz
          test.log
          test.mp3
        }
      )

      if short_filedir == 1
        start_dir = ""
      else
        @tty.send_keys("FZF_OBC_SHORT_FILEDIR=0","#{ENTER}")
        @tty.clear_screen()
        start_dir = "#{temp_test_dir}/"
      end

      @tty.send_keys("insmod #{temp_test_dir}/","#{TAB}", delay: 0.01)
      @tty.assert_matches(<<~EOF)
        $ insmod #{temp_test_dir}/
        >
          3/3
        > #{start_dir}d1/
          #{start_dir}test.ko.gz
          #{start_dir}test 1.ko.gz
      EOF
      @tty.send_keys("#{DOWN}")
      @tty.send_keys("#{DOWN}")
      @tty.send_keys("#{TAB}")
      @tty.assert_row(0,"$ insmod #{temp_test_dir}/test\\ 1.ko.gz")
      @tty.clear_screen()
    end
  end
end
