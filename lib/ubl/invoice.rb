require 'ubl/parse'
require 'ubl/maybes'

module UBL
  module Invoice
    include UBL::Parse
    include UBL::Maybes
    
    def maybe_find_period(invoice_el, &bl)
      period_set = {
        starts: "#{ns(invoice_el, :cac)}:InvoicePeriod/#{ns(invoice_el, :cbc)}:StartDate",
        ends:   "#{ns(invoice_el, :cac)}:InvoicePeriod/#{ns(invoice_el, :cbc)}:EndDate",
      }
      
      maybe_find_set_text(invoice_el, period_set) do |s|
        bl.call(s) if bl
      end
    end
    
    def maybe_find_parties(invoice_el, &bl)
      parties_set = {
        supplier: "#{ns(invoice_el, :cac)}:AccountingSupplierParty/#{ns(invoice_el, :cac)}:Party",
        customer: "#{ns(invoice_el, :cac)}:AccountingCustomerParty/#{ns(invoice_el, :cac)}:Party",
        payer:    "#{ns(invoice_el, :cac)}:PayeeParty",
      }
      maybe_find_set(invoice_el, parties_set) do |parties_els|
        parties = parties_els.inject({}) do |o, kv|
          o.merge(kv.first => make_party(kv.last))
        end
        bl.call(parties) if parties.any? && bl
      end
    end
    
    def make_party(party_el)
    # ignoring: cbc:EndpointID, cbc:ID
      {}.tap do |o|
        maybe_find_one_text(party_el, "#{ns(party_el, :cac)}:PartyIdentification/#{ns(party_el, :cbc)}:ID") do |text|
          o[:id] = text
        end
        maybe_find_one_text(party_el, "#{ns(party_el, :cac)}:PartyName/#{ns(party_el, :cbc)}:Name") do |text|
          o[:name] = text
        end
        maybe_find_one_convert(:make_address, party_el, "#{ns(party_el, :cac)}:PostalAddress") do |a|
          o[:address] = a
        end
        maybe_find_one_convert(:make_legal, party_el, "#{ns(party_el, :cac)}:PartyLegalEntity") do |l|
          o[:legal] = l
        end
        maybe_find_one_convert(:make_contact, party_el, "#{ns(party_el, :cac)}:Contact") do |contact|
          o[:contact] = contact
        end
        maybe_find_one_convert(:make_person, party_el, "#{ns(party_el, :cac)}:Person") do |person|
          o[:person] = person
        end
      end
    end
    
    def make_address(n)
      {}.tap do |o|
        maybe_find_one_text(n, "#{ns(n, :cbc)}:CityName") do |text|
          o[:city] = text
        end
        maybe_find_one_text(n, "#{ns(n, :cac)}:Country/#{ns(n, :cbc)}:IdentificationCode") do |text|
          o[:country_code] = text
        end
      end
    end

    def make_legal(n)
      # not handling cbc:CompanyID
      {}.tap do |o|
        maybe_find_one_text(n, "#{ns(n, :cbc)}:RegistrationName") do |text|
          o[:name] = text
        end
        maybe_find_one_convert(:make_address, n, "#{ns(n, :cac)}:RegistrationAddress") do |a|
          o[:address] = a
        end
      end
    end

    def make_contact(n)
      {}.tap do |o|
        maybe_find_one_text(n, "#{ns(n, :cbc)}:Telephone") do |text|
          o[:telephone] = text
        end
        maybe_find_one_text(n, "#{ns(n, :cbc)}:Telefax") do |text|
          o[:fax] = text
        end
        maybe_find_one_text(n, "#{ns(n, :cbc)}:ElectronicMail") do |text|
          o[:email] = text
        end
      end
    end

    def make_person(n)
      @names_set ||= {
        first:  "#{ns(n, :cbc)}:FirstName",
        family: "#{ns(n, :cbc)}:FamilyName",
        other:  "#{ns(n, :cbc)}:OtherName",
        middle: "#{ns(n, :cbc)}:MiddleName",
      }
      {}.tap do |o|
        maybe_find_set_text(n, @names_set) do |names|
          o[:name] = names
        end
        maybe_find_one_text(n, "#{ns(n, :cbc)}:JobTitle") do |text|
          o[:title] = text
        end
      end
    end
  end
end
