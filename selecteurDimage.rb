# encoding: UTF-8

##
# auteur :Groupe 2
#
# Le fichier <b>selecteurDimage.rb</b> comporte les procédures suivantes :
# => -initialisation d'une fenêtre avec Gtk prenant en paramètre le tube d'écriture ouvert par <b>image.rb</b> et permettant la navigation dans les fichiers de l'ordinateur pour selectionner une image (#initialize)
# => -fonction chargeant la nouvelle image (#charger_image)
# => -fonction d'envoi de l'image dans le tube d'écriture(#envoi)

require 'gtk2'



class SelecteurDimage < Gtk::Builder

	@tube

  def initialize(tubeEcriture)
    super()
    @tube = tubeEcriture
    self.add_from_file(__FILE__.sub(".rb",".glade"))

    #self['filechooserdialog1'].set_window_position Gtk::Window::POS_CENTER
    self['filechooserdialog1'].signal_connect('destroy') { @filechooserdialog1.destroy }
    self['filechooserdialog1'].show_all

    @filter = Gtk::FileFilter.new
    @filter.add_pattern("*.jpg")
    @filter.add_pattern("*.png")
    self['filechooserdialog1'].filter = @filter

    # Creation d'une variable d'instance par composant glade
    self.objects.each() { |p|
    	puts p
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
     }

     self.connect_signals{ |handler|
        puts handler
        method(handler)
      }


  end

  ##
  # fonction chargeant depuis l'ordinateur de l'utilisateur l'image qu'il a selectionné et lui attribuant une taille donné en pixel
  	def charger_image()
      		image_file_name= @filechooserdialog1.filename
      		p image_file_name
      		begin

      			puts @image1.set_pixbuf Gdk::Pixbuf.new(image_file_name,180,300)
      		rescue
      			puts "probleme chargement image #{image_file_name}"
      		end

      end
  ##
  #
  # fonction d'envoi de l'image dans le tube d'écriture ouvert préalablement 
  #
      def envoi()
      	@tube.puts @filechooserdialog1.filename
        @filechooserdialog1.destroy
      end

end

#Gtk.init
#selecteurDimage = SelecteurDimage.new()
#Gtk.main
