require 'lotus/view/rendering/template_finder'

module Lotus
  module View
    module Rendering
      # Rendering template
      #
      # It's used when a template wants to render another template.
      #
      # @api private
      # @since 0.1.0
      #
      # @see Lotus::View::Rendering::LayoutScope#render
      #
      # @example
      #   # We have an application template (templates/application.html.erb)
      #   # that uses the following line:
      #
      #   <%= render template: 'articles/show' %>
      class Template
        # Initialize a template
        #
        # @param view [Lotus::View] the current view
        # @param options [Hash] the rendering informations
        # @option options [Symbol] :format the current format
        # @option options [Hash] :locals the set of objects available within
        #   the rendering context
        #
        # @api private
        # @since 0.1.0
        def initialize(view, options)
          @view, @options = view, options
        end

        # Render the template.
        #
        # @return [String] the output of the rendering process.
        #
        # @raise [Lotus::View::MissingTemplateError] if template can't be found
        #
        # @api private
        # @since 0.1.0
        def render
          (template or raise_missing_template_error).render(scope)
        end

        protected
        def template
          TemplateFinder.new(@view.class, @options).find
        end

        def scope
          Scope.new(@view, @options[:locals])
        end

        # @since x.x.x
        # @api private
        def raise_missing_template_error
          raise MissingTemplateError.new(
            @options.fetch(:template) { @options.fetch(:partial, nil) },
            @options[:format]
          )
        end
      end
    end
  end
end
