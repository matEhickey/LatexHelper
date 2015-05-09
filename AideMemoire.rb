class AideMemoire < Gtk::Builder
	

  def initialize 
    super()

    self.add_from_file(__FILE__.sub(".rb",".glade"))
    
    self['window1'].set_window_position Gtk::Window::POS_CENTER
    self['window1'].signal_connect('destroy') { detruire }
    self['window1'].set_title("Generateur LaTex");
    
    
    # Creation d'une variable d'instance par composant glade
    self.objects.each() { |p|
        instance_variable_set("@#{p.builder_name}".intern, self[p.builder_name])
     }

     self.connect_signals{ |handler| 
        puts handler
        method(handler)
      }

      self['window1'].show_all
  end
  
  def load_image
		puts "appel a load_image"
		pipeReader,pipeWritter = IO.pipe
		@selecteurDimage = SelecteurDimage.new(pipeWritter);
		t1 = Thread.new(){
				filename = pipeReader.gets.delete!("\n")
				#puts filename = pipeReader.read
				@image1.file=(filename)
				puts filename.class
		}
	end
  
  def detruire
  	@window1.hide
  end
  
end
