class Apitome::DocsController < ActionController::Base

  layout Apitome.configuration.layout

  helper_method :resources, :example, :formatted_body, :param_headers, :param_extras, :formatted_readme

  def index
  end

  def show
  end

  private

  def file_for(file)
    file = Apitome.configuration.root.join(Apitome.configuration.doc_path, file)
    return '' unless File.exists?(file)
    File.read(file)
  end

  def resources
    @resources ||= JSON.parse(file_for('index.json'))['resources']
  end

  def example
    @example ||= JSON.parse(file_for("#{params[:path]}.json"))
  end

  def formatted_readme
    file = Apitome.configuration.root.join(Apitome.configuration.doc_path, Apitome.configuration.readme)
    GitHub::Markdown.render_gfm(file_for(file))
  end

  def formatted_body(body, type)
    if type =~ /json/
      JSON.pretty_generate(JSON.parse(body))
    else
      body
    end
  end

  def param_headers(params)
    titles = %w{Name Description}
    titles += param_extras(params)
  end

  def param_extras(params)
    extras = []
    for param in params
      extras += param.reject{ |k,v| %w{name description required scope}.include?(k) }.keys
    end
    extras.uniq
  end

end
