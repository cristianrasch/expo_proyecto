require "spec_helper"

describe MessagesMailer do
  describe "new_message" do
    let(:mail) do 
      message = Message.new(:recipients => ["test@example.com"], :subject => "xxx", :text => "zzz")
      MessagesMailer.new_message(message)
    end

    it "renders the headers" do
      mail.subject.should eq("xxx")
      mail.to.should eq(["test@example.com"])
      mail.from.should include(Conf.devise['mailer_sender'])
    end

    it "renders the body" do
      mail.body.encoded.should match("zzz")
    end
  end

end
