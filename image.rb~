# encoding: UTF-8

##
# auteur :Groupe 2
#
# Le fichier <b>image.rb</b> comporte les procèdures suivantes :
# => -initialisation d'une fenêtre avec gtk (#initialize)
# => -fonction ouvrant la récupération d'une nouvelle image sur le pc de l'utilisateur(#load_image)
# => -fermeture de la page actuelle et de toutes les fenêtres filles lancées (#onDestroy).

require 'gtk2'
require './selecteurDimage.rb'



class Builder < Gtk::Builder

	@selecteurDimage

  
  def initialize 
    super()
    self.add_from_file(__FILE__.sub(".rb",".glade"))
    
    self['window1'].set_window_position Gtk::Window::POS_CENTER
    self['window1'].signal_connect('destroy') { Gtk.main_quit }
    self['window1'].show_all
    
    # Creation d'une variable d'instance par composant glade
    self.objects.each() { |p|
    	puts p
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
     }

     self.connect_signals{ |handler| 
        method(handler)
      }
      
  end
  ##
  # fonction ouvrant un chemin pour récupérer une image sur l'ordinateur de l'utilisateur
  #	
	def load_image
		puts "appel a load_image"
		pipeReader,pipeWritter = IO.pipe
		@selecteurDimage = SelecteurDimage.new(pipeWritter);
		t1 = Thread.new(){
				filename = pipeReader.gets.delete!("\n")
				#puts filename = pipeReader.read
				puts filename
		}
		
		
	end
  ##
  # Méthode <b>onDestroy</b>
  # fermeture de toutes les fenêtres filles lancées
  #
	def onDestroy
		puts "appel a onDestroy"
		Gtk.main_quit
	end


end

Gtk.init
builder = Builder.new()
Gtk.main
