module APIS
  module V1
    class Invoices < Grape::API
      include APIS::V1::Defaults

      helpers do
        # define helpers with a block
        def invoices_data(data)
          res = {}
          for entity in data.to_h['content']['entities']
            country = entity['address']['c']
            res[country] = res[country] ? res[country] + entity['invoices'].count : 1
          end
          res
        end
      end

      # GET /api/v1/invoices
      resource :invoices do
        get "/" do
          params = {
              engine: 'invoices/list',
              'metadata[entity]' => 'customers | suppliers'
          }
          data = make_request(params)
          invoices_data(data)
        end
      end
    end
  end
end

