module APIS
  module V1
    class Base < Grape::API
      # base api for v1
      mount APIS::V1::Employees
      mount APIS::V1::Invoices
    end
  end
end

