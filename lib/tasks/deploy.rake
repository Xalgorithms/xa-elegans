namespace :deploy do
  desc 'boot workers'
  task :boot_workers, [] => :environment do |t, args|
    Rails.logger.info('^ booting tradeshift worker')
    TradeshiftWorker.perform_async
  end
end
