require 'launchy'

Capybara::SpecHelper.spec '#save_and_open_screenshot' do
  before do
    @session.visit '/'
  end

  it 'opens file from the default directory', :requires => [:screenshot] do
    expected_file_regex = %r{capybara/capybara-\d+\.png}
    @session.driver.stub(:save_screenshot)
    Launchy.stub(:open)

    @session.save_and_open_screenshot

    expect(@session.driver).to have_received(:save_screenshot).
      with(expected_file_regex, {})
    expect(Launchy).to have_received(:open).with(expected_file_regex)
  end

  it 'opens file from the provided directory', :requires => [:screenshot] do
    custom_path = 'screenshots/1.png'
    @session.driver.stub(:save_screenshot)
    Launchy.stub(:open)

    @session.save_and_open_screenshot(custom_path)

    expect(@session.driver).to have_received(:save_screenshot).
      with(custom_path, {})
    expect(Launchy).to have_received(:open).with(custom_path)
  end

  context 'when launchy cannot be required' do
    it 'prints out a correct warning message', :requires => [:screenshot] do
      file_path = File.join(Dir.tmpdir, 'test.png')
      @session.stub(:require).with('launchy').and_raise(LoadError)
      @session.stub(:warn)

      @session.save_and_open_screenshot(file_path)

      expect(@session).to have_received(:warn).
        with("File saved to #{file_path}.")
      expect(@session).to have_received(:warn).
        with('Please install the launchy gem to open the file automatically.')
    end
  end
end