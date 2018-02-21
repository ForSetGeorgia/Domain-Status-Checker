require 'dotenv'
Dotenv.load

require 'mail'
require 'subexec'

def run_domain_check
  # only continue if there are domains to check
  if !ENV['DOMAINS'].nil? && ENV['DOMAINS'].length > 0

    # put the domains into an array
    domains = ENV['DOMAINS'].split(',').map{|x| x.strip}
    outputs = []

    # run the whois command for each domain
    domains.each do |domain|
      result = Subexec.run "whois #{domain} | grep 'Domain Status'"
      outputs << [domain, result.output]
    end


    # write the body in the format of domain / output message
    body = ''
    outputs.each do |output|
      body << output[0].gsub("\n", "<br />")
      body << "<br />"
      body << output[1].gsub("\n", "<br />")
      body << "<br />"
      body << "-------------------------------------------------------"
      body << "<br /><br />"
    end


    # set the mail settings
    if ENV['ENVIRONMENT'] == 'production'
      Mail.defaults do
        delivery_method :smtp,
                        address: ENV['FEEDBACK_SMTP_ADDRESS'],
                        port: '587',
                        user_name: ENV['FEEDBACK_SMTP_AUTH_USER'],
                        password: ENV['FEEDBACK_SMTP_AUTH_PASSWORD'],
                        authentication: :plain,
                        enable_starttls_auto: true
      end
    else
      Mail.defaults do
        delivery_method :smtp,
                        address: 'localhost',
                        port: 1025
      end
    end

    mail = Mail.new do
      from    ENV['FEEDBACK_FROM_EMAIL']
      to      ENV['FEEDBACK_TO_EMAIL']
      subject ENV['EMAIL_SUBJECT']

      html_part do
        content_type 'text/html; charset=UTF-8'
        body body
      end
    end
    # mail[:body] = body

    # send the email
    mail.deliver!

  end
end