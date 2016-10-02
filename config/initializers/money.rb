bank = EuCentralBank.new

if !Rails.env.test?
  cache_dir = Rails.root.join('tmp', 'cache')
  FileUtils.mkdir_p(cache_dir) if !Dir.exists?(cache_dir)
  cf = File.join(cache_dir, 'eu_bank_rates.xml')
  bank.save_rates(cf)
  bank.update_rates(cf)

  if !bank.rates_updated_at || bank.rates_updated_at < (Time.now - 1.days)
    bank.save_rates(cf)
    bank.update_rates(cf)
  end
end

Money.default_bank = bank
