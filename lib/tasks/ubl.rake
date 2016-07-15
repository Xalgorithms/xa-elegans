namespace :ubl do
  require 'awesome_print'
  require 'ubl'
  
  desc 'parse an invoice file'
  task :parse_invoice, [:file] => :environment do |t, args|
    if args.file
      include UBL::Invoice
      
      parse_urn(args.file) do |invoice|
        ap invoice
      end
    else
      puts "! filename"
    end
  end
end
