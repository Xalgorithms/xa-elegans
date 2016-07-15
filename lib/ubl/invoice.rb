require 'ubl/parse'
require 'ubl/maybes'

module UBL
  module Invoice
    include UBL::Parse
    include UBL::Maybes

    def parse(urn, &bl)
      load_and_parse(urn, :root_xp, :make_invoice, &bl)
    end
    
    def root_xp(doc)
      "#{ns(doc, :invoice)}:Invoice"
    end
    
    def maybe_find_period(el, &bl)
      period_set = {
        starts: "#{ns(el, :cac)}:InvoicePeriod/#{ns(el, :cbc)}:StartDate",
        ends:   "#{ns(el, :cac)}:InvoicePeriod/#{ns(el, :cbc)}:EndDate",
      }
      
      maybe_find_set_text(el, period_set) do |s|
        bl.call(s) if bl
      end
    end
    
    def maybe_find_parties(el, &bl)
      parties_set = {
        supplier: "#{ns(el, :cac)}:AccountingSupplierParty/#{ns(el, :cac)}:Party",
        customer: "#{ns(el, :cac)}:AccountingCustomerParty/#{ns(el, :cac)}:Party",
        payer:    "#{ns(el, :cac)}:PayeeParty",
      }
      maybe_find_set(el, parties_set) do |parties_els|
        parties = parties_els.inject({}) do |o, kv|
          o.merge(kv.first => make_party(kv.last))
        end
        bl.call(parties) if parties.any? && bl
      end
    end

    def make_invoice(el)
      {}.tap do |o|
        maybe_find_one_text(el, "#{ns(el, :cbc)}:ID") do |text|
          o[:id] = text
        end
        maybe_find_one_text(el, "#{ns(el, :cbc)}:IssueDate") do |text|
          o[:issued] = text
        end
        maybe_find_one_text(el, "#{ns(el, :cbc)}:DocumentCurrencyCode") do |text|
          o[:currency] = text
        end
        
        maybe_find_period(el) do |period|
          o[:period] = period
        end
        
        maybe_find_parties(el) do |parties|
          o[:parties] = parties
        end
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
