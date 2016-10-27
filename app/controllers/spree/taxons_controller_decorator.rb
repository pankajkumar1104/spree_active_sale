module Spree
  TaxonsController.class_eval do
    before_action :load_view_type

    def show
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      if @taxon.live?
        @searcher = Spree::Config.searcher_class.new(params.merge(taxon: @taxon.id))
        @objects = @searcher.send(@retrieve_type) #retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
      else
        redirect_to root_url, error: Spree.t(:error, scope: [:active_sale, :event, :flash])
      end
    end

    private

      def load_view_type
        if params[:view_type].present? && params[:view_type] == 'sales'
          @view_type = 'sale_events'
          @retrieve_type = 'retrieve_sales'
        else
          @view_type = 'products'
          @retrieve_type = 'retrieve_products'
        end
      end
  end
end
