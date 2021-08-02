require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require 'active_support/inflector'

class ControllerBase
  attr_reader :req, :res, :params
  # attr_accessor :already_built_response

  # Setup the controller
  def initialize(req, res)
    @req = req
    @res = res
    @already_built_response = false
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'error' if already_built_response?
    @res.status = 302
    @res['Location'] = url
    @already_built_response = true
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise 'error' if already_built_response?
    @res.write(content)
    @res['Content-Type'] = content_type
    @already_built_response = true
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    raise 'error' if already_built_response?
    # File.dirname("views/#{controller_name}/#{template_name}.html.erb")
    # File.join('')
    # ERB.new(file).result(binding)
    # file = 

    directory = File.dirname(__FILE__)

    entire_path = File.join(
      directory, 
      '..', 
      'views', 
      self.class.name.underscore, 
      "#{template_name}.html.erb")
      
    file_location = File.read(entire_path)

    render_content(
      ERB.new(file_location).result(binding), 
      "text/html")

    @already_built_response = true
  end

  # method exposing a `Session` object
  def session
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

