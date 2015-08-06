module APIS
  module V1
    class Employees < Grape::API
      include APIS::V1::Defaults

      helpers do
        # define helpers with a block
        def employees_data(data)
          res = {}
          for emp in data.to_h['content']['employees']
            city = Geocoder.search(emp['address']).first.city
            res[city] = res[city] ? res[city] + 1 : 1
          end
          res
        end
      end

      # GET /api/v1/employees
      resource :employees do
        get "/" do
          params = {engine: 'hr/employees_list'}
          data = make_request(params)
          employees_data(data)
        end
      end
    end
  end
end

