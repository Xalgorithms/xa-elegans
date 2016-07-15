require 'countries'
require 'currencies'
require 'nokogiri'
require 'ostruct'

class NodeWrapper
  NAMESPACE_URNS = {
    invoice: 'urn:oasis:names:specification:ubl:schema:xsd:Invoice-2',
    cac:     'urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2',
    cbc:     'urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2',
  }

  def self.maybe_make_one(xp, pn)
    n = pn.xpath(xp).first if pn
    o = self.new(n) if n
    yield(o) if o
    o
  end

  def maybe_find_one(xp, pn = nil, &bl)
    rv = (pn || @node).xpath(xp).first
    rv = bl.call(rv) if rv && bl
    rv
  end
  
  def maybe_find_one_text(xp, pn = nil, &bl)
    maybe_find_one(xp, pn) do |n|
      rv = n.text
      rv = bl.call(rv) if bl
      rv
    end
  end

  def maybe_find_one_date(xp, pn = nil, &bl)
    maybe_find_one_text(xp, pn) do |text|
      rv = Date.parse(text)
      rv = bl.call(rv) if bl
      rv
    end
  end

  def maybe_find_one_currency(xp, pn = nil, &bl)
    maybe_find_one_text(xp, pn) do |text|
      # this does not check that the gc list matches ISO4217
      rv = ISO4217::Currency.from_code(text)
      rv = bl.call(rv) if rv && bl
      rv
    end
  end

  def maybe_find_one_country(xp, pn = nil, &bl)
    maybe_find_one_text(xp, pn) do |text|
      rv = ISO3166::Country.new(text)
      rv = bl.call(rv) if bl
      rv
    end
  end
  
  def initialize(n)
    @node = n
    doc_nses = @node.document.namespaces.invert
    @nses = NAMESPACE_URNS.keys.inject({}) do |o, k|
      o.merge(k => doc_nses[NAMESPACE_URNS[k]].split(':').last)
    end
  end
end

class Invoice < NodeWrapper
  def id
    @id ||= maybe_find_one_text("#{@nses[:invoice]}:Invoice/#{@nses[:cbc]}:ID")
  end

  def issued
    @issued ||= maybe_find_one_date("#{@nses[:invoice]}:Invoice/#{@nses[:cbc]}:IssueDate")
  end

  def currency
    @currency ||= maybe_find_one_currency("#{@nses[:invoice]}:Invoice/#{@nses[:cbc]}:DocumentCurrencyCode")
  end

  def period
    maybe_find_one("#{@nses[:invoice]}:Invoice/#{@nses[:cac]}:InvoicePeriod") do |pn|
      @period = OpenStruct.new(
        {}.tap do |o|
          maybe_find_one_date("#{@nses[:cbc]}:StartDate", pn) do |dt|
            o[:starts] = dt
          end
          maybe_find_one_date("#{@nses[:cbc]}:EndDate", pn) do |dt|
            o[:ends] = dt
          end
        end)
    end if !@period

    @period
  end

  def parties
    maybe_find_one("#{@nses[:invoice]}:Invoice") do |pn|
      @parties = OpenStruct.new(
        {}.tap do |o|
          maybe_find_one_party("#{@nses[:cac]}:AccountingSupplierParty/#{@nses[:cac]}:Party", pn) do |pt|
            o[:supplier] = pt
          end
          maybe_find_one_party("#{@nses[:cac]}:AccountingCustomerParty/#{@nses[:cac]}:Party", pn) do |pt|
            o[:customer] = pt
          end
          maybe_find_one_party("#{@nses[:cac]}:PayeeParty", pn) do |pt|
            o[:payer] = pt
          end
        end)
    end if !@parties
    
    @parties
  end

  private

  def maybe_find_one_party(xp, pn = nil)
    maybe_find_one(xp, pn) do |n|
      pt = party(n)
      yield(pt)
      pt
    end
  end
  
  def party(n)
    # ignoring: cbc:EndpointID, cbc:ID
    OpenStruct.new(
      {}.tap do |o|
        maybe_find_one_text("#{@nses[:cac]}:PartyIdentification/#{@nses[:cbc]}:ID", n) do |text|
          o[:id] = text
        end
        maybe_find_one_text("#{@nses[:cac]}:PartyName/#{@nses[:cbc]}:Name", n) do |text|
          o[:name] = text
        end
        Address.maybe_make_one("#{@nses[:cac]}:PostalAddress", n) do |a|
          o[:address] = a
        end
        maybe_find_one("#{@nses[:cac]}:PartyLegalEntity", n) do |len|
          # ignoring: cbc:CompanyID
          o[:legal] = OpenStruct.new(
            {}.tap do |o|
              maybe_find_one_text("#{@nses[:cbc]}:RegistrationName", len) do |text|
                o[:name] = text
              end
              Address.maybe_make_one("#{@nses[:cac]}:RegistrationAddress", len) do |a|
                o[:address] = a
              end
            end)
        end
        Contact.maybe_make_one("#{@nses[:cac]}:Contact", n) do |c|
          o[:contact] = c
        end
        Person.maybe_make_one("#{@nses[:cac]}:Person", n) do |pr|
          o[:person] = pr
        end
      end)
  end
end

class Address < NodeWrapper
    # cbc:ID, AddressTypeCode, AddressFormatCode are ignored
  def city
    @city ||= maybe_find_one_text("#{@nses[:cbc]}:CityName")
  end

  def country
    # doesn't verify the list
    @country ||= maybe_find_one_country("#{@nses[:cac]}:Country/#{@nses[:cbc]}:IdentificationCode")
  end
end

class Contact < NodeWrapper
  def telephone
    @telephone ||= maybe_find_one_text("#{@nses[:cbc]}:Telephone")
  end

  def fax
    @fax ||= maybe_find_one_text("#{@nses[:cbc]}:Telefax")
  end

  def email
    @email ||= maybe_find_one_text("#{@nses[:cbc]}:ElectronicMail")
  end
end

class Person < NodeWrapper
  def name
    @name ||= OpenStruct.new(
      {}.tap do |o|
        maybe_find_one_text("#{@nses[:cbc]}:FirstName") do |text|
          o[:first] = text
        end
        maybe_find_one_text("#{@nses[:cbc]}:FamilyName") do |text|
          o[:family] = [text]
        end
        maybe_find_one_text("#{@nses[:cbc]}:OtherName") do |text|
          o[:family] << text
        end
        maybe_find_one_text("#{@nses[:cbc]}:MiddleName") do |text|
          o[:middle] = [text]
        end
      end)
  end

  def title
    @title ||= maybe_find_one_text("#{@nses[:cbc]}:JobTitle")
  end
end

doc = Nokogiri::XML(open('ubl/documents/UBL-Invoice-2.1-Example.xml')) do |cfg|
  cfg.noblanks.noent
end

inv = Invoice.new(doc)

p inv.id
p inv.issued
p inv.currency
p [:period, inv.period.starts, inv.period.ends]
p [:supplier, inv.parties.supplier.name, inv.parties.supplier.address.city, inv.parties.supplier.address.country.name]
p [:supplier_legal, inv.parties.supplier.legal.name, inv.parties.supplier.legal.address.country.name]
p [:supplier_contact, inv.parties.supplier.contact.telephone, inv.parties.supplier.contact.email]
p [:supplier_person, inv.parties.supplier.person.name, inv.parties.supplier.person.title]
p [:customer, inv.parties.customer.name, inv.parties.customer.address.city, inv.parties.customer.address.country.name]
p [:customer_legal, inv.parties.customer.legal.name, inv.parties.customer.legal.address.country.name]
p [:customer_contact, inv.parties.customer.contact.telephone, inv.parties.customer.contact.email]
p [:customer_person, inv.parties.customer.person.name, inv.parties.customer.person.title]
p [:payer, inv.parties.payer.name]
