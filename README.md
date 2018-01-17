# Domain Status Checker

This program runs a whois command to check on the status of a domain(s). The result is then sent in an email.

## Getting Started

1. `bundle install`
2. `cp .env.example .env`
3. Fill in `.env` variables. Unless you set ENVIRONMENT to production, emails will be sent to mailcatcher and you can use any fake email addresses you want.

### Environment Variables

- ENVIRONMENT - set to production so email will actually be set
- DOMAINS - comma separated list of domains to check. Example: 'forset.ge' or 'forset.ge, datafest.ge'
- EMAIL_SUBJECT - the subject line for the email notification

## Usage

- `rake domain_cheker:run` -> Run the scraper!
- `rake domain_cheker:schedule:run_daily` -> Schedule a cron job to run `rake domain_cheker:run` according to the confid/schedule.rb file.

## How it Works

When you run the domain checker, the following happens:

1. Each domain is checked using the command: whois domain | grep 'Domain Status'
2. The output is recorded
3. An notification of the output is emailed
