require 'swagger_helper'

RSpec.describe 'articles', type: :request do

  path '/articles' do

    get('list articles') do
      response(200, 'successful') do
        Article.create!(title: 'This is my first article', body: 'This is the body')

        after do |example|
          article = JSON.parse(response.body, symbolize_names: true)[:data].first

          expect(article[:attributes][:title]).to eq('This is my first article')
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create article') do
      consumes 'application/json'
      parameter name: :article, in: :body, schema: {
        type: :object,
        properties: {
          title: { type: :string, example: 'This is a default title' },
          body: { type: :string, example: 'This is a default body' }
        },
        required: [ 'title', 'body' ]
      }

      response(201, 'successful') do
        let(:article) { { title: 'foo', body: 'bar' } }

        after do |example|
          article = JSON.parse(response.body, symbolize_names: true)[:data]

          expect(article[:attributes][:title]).to eq 'foo'
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/articles/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show article') do
      response(200, 'successful') do
        let(:id) { Article.create!(title: 'This is a title', body: 'This is a body').id }

        after do |example|
          article = JSON.parse(response.body, symbolize_names: true)[:data]
          expect(article[:attributes][:title]).to eq 'This is a title'

          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

  #   patch('update article') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   put('update article') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end

  #   delete('delete article') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }

  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  end
end
