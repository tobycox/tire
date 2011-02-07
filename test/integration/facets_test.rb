require 'test_helper'

module Slingshot

  class FacetsIntegrationTest < Test::Unit::TestCase
    include Test::Integration

    context "Facets" do

      should "return results scoped to current query" do
        q = 'tags:ruby'
        s = Slingshot.search('articles-test') do
          query { string q }
          facet 'tags' do
            terms :tags
          end
        end
        facets = s.results.facets['tags']['terms']
        assert_equal 2, facets.count
        assert_equal 'ruby', facets.first['term']
        assert_equal 2,      facets.first['count']
      end

      should "allow to specify global facets and query-scoped facets" do
        q = 'tags:ruby'
        s = Slingshot.search('articles-test') do
          query { string q }
          facet 'scoped-tags' do
            terms :tags
          end
          facet 'global-tags', :global => true do
            terms :tags
          end
        end

        scoped_facets = s.results.facets['scoped-tags']['terms']
        global_facets = s.results.facets['global-tags']['terms']

        assert_equal 2, scoped_facets.count
        assert_equal 5, global_facets.count
      end

    end

  end

end
