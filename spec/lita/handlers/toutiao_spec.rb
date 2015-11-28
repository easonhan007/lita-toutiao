require "spec_helper"

describe Lita::Handlers::Toutiao, lita_handler: true do
  it {is_expected.to route_command("toutiao").to(:fetch_toutiao)}

  it 'should get content form toutiao' do
    send_command('toutiao')
    #puts replies.last
    expect(replies.last).to include('toutiao.io')
  end
end
