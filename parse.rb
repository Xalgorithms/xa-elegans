require 'nokogiri'

module UBL
  module Parse
    def parse(urn)
      load(urn) do |doc|
        invoice = {}.tap do |o|
          maybe_find_one(doc, "#{ns(doc, :invoice)}:Invoice") do |invoice_el|
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:ID") do |text|
              o[:id] = text
            end
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:IssueDate") do |text|
              o[:issued] = text
            end
            maybe_find_one_text(invoice_el, "#{ns(doc, :cbc)}:DocumentCurrencyCode") do |text|
            o[:currency] = text
            end
            
            maybe_find_period(invoice_el) do |period|
              o[:period] = period
            end
            
            maybe_find_parties(invoice_el) do |parties|
              o[:parties] = parties
            end
          end
        end
        
        yield(invoice)
      end
    end

    def load(urn)
      doc = Nokogiri::XML(open(urn)) do |cfg|
        cfg.noblanks.noent
      end
      yield(doc) if doc
    end
    
    def ns(n, k)
      if !@nses
        @namespace_urns ||= {
          invoice: 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
          cac:     'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
          cbc:     'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
        }
        doc_nses = n.document.namespaces.invert
        @nses = @namespace_urns.keys.inject({}) do |o, k|
          o.merge(k => doc_nses[@namespace_urns[k]].split(':').last)
        end
      end
      
      @nses[k]
    end
  end
  
  module Maybes
    def maybe_find_one(pn, xp, &bl)
      rv = pn.xpath(xp).first
      rv = bl.call(rv) if rv && bl
      rv
    end

    def maybe_find_set(pn, xp_set, &bl)
      rv = xp_set.keys.inject({}) do |o, k|
        maybe_find_one(pn, xp_set[k]) do |n|
          o = o.merge(k => n)
        end

        o
      end
      rv = bl.call(rv) if rv.any? && bl
      rv
    end

    def maybe_find_set_text(pn, xp_set, &bl)
      rv = {}
      maybe_find_set(pn, xp_set) do |s|
        rv = s.inject({}) do |o, kv|
          o.merge(kv.first => kv.last.text)
        end
      end

      rv = bl.call(rv) if rv.any? && bl
      rv
    end
    
    def maybe_find_one_text(pn, xp, &bl)
      maybe_find_one(pn, xp) do |n|
        rv = n.text
        rv = bl.call(rv) if bl
        rv
      end
    end
    
    def maybe_find_one_convert(sym, pn, xp, &bl)
      maybe_find_one(pn, xp) do |n|
        rv = send(sym, n)
        rv = bl.call(rv) if rv && rv.any? && bl
        rv
      end
    end
  end
  
  module Invoice
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

include UBL::Parse
include UBL::Maybes
include UBL::Invoice

parse('ubl/documents/UBL-Invoice-2.1-Example.xml') do |invoice|
  p invoice
end
