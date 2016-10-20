Rails.logger.info('booting initial tradeshift worker')
TradeshiftWorker.perform_async
