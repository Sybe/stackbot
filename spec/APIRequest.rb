require 'rest-client'
require 'json'

class APIRequest
  def initialize(token, administration)
  	@token = token
  	@administration = administration
  end

  def purchase_invoices
    begin
      request_result = RestClient.get 'https://moneybird.com/api/v2/' + @administration + '/documents/purchase_invoices.json?filter=state:open|late', authorization: "Bearer " + @token
      my_hash = JSON.parse(request_result)
      result = []
      my_hash.each do |invoice|
        # kans op afrondfouten door rekenen met float
        result.push('Aan ' + invoice['contact']['company_name'] + ' te betalen: ' + Money.new(invoice['total_price_excl_tax'].to_f * 100, invoice['currency']).format +
          "\nFactuur ontvangen op " + invoice['date'])
      end
      return result
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      puts err.response
      puts err
    end
  end

  def purchase_invoices_late
    begin
      request_result = RestClient.get 'https://moneybird.com/api/v2/' + @administration + '/documents/purchase_invoices.json?filter=state:late', authorization: "Bearer " + @token
      my_hash = JSON.parse(request_result)
      result = []
      my_hash.each do |invoice|
        # kans op afrondfouten door rekenen met float
        result.push('Aan ' + invoice['contact']['company_name'] + ' te betalen: ' + Money.new(invoice['total_price_excl_tax'].to_f * 100, invoice['currency']).format +
          "\nFactuur ontvangen op " + invoice['date'])
      end
      return result
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      puts err.response
      puts err
    end
  end

  def sale_invoices
    begin
      request_result = RestClient.get 'https://moneybird.com/api/v2/' + @administration + '/sales_invoices.json?filter=state:late', authorization: "Bearer " + @token
      my_hash = JSON.parse(request_result)
      result = []
      my_hash.each do |invoice|
        # kans op afrondfouten door rekenen met float
        result.push(invoice['contact']['company_name'] + ' is te laat met betalen: ' + Money.new(invoice['total_unpaid'].to_f * 100, invoice['currency']).format +
          "\nHad betaald moeten worden op " + invoice['due_date'])
      end
      return result
    rescue RestClient::Unauthorized, RestClient::Forbidden => err
      puts 'Access denied'
      puts err.response
      puts err
    end
  end
end