# encoding: UTF-8
class ReporterMailer < ActionMailer::Base
  default from: "#{I18n.t(:app_name)} <bairro.app@gmail.com>"

  def reporter_email(report)
    @report = report
    name_and_mail_destination = "#{report.user.uuid}"
    small_description = truncate(report.description)
    mail(:to => name_and_mail_destination, :subject => "Problema (#{report.municipality.name}) - #{small_description}")
  end

  def truncate(text)
    clean_text = text.gsub(/\r\n/,' ').gsub(/\r/,' ')
    clean_text[0..17] + (clean_text.size > 17 ? '...' : '')
  end

end
