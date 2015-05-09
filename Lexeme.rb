class Lexeme
	@type
	@value
	attr_reader :type, :value
	def initialize(type,value)
		@type = type
		@value = value
	end
	

	
	def to_s
		if(@type == "section")
			chaine = "\\section{#{@value}}\n"
		elsif(@type == "subsection")
			chaine = "\\begin{subsection}{#{@value}}\n"
		elsif(@type == "block" )
			chaine = "\\begin{block}{#{@value}}\n"
		elsif(@type == "text")
			chaine = "#{@value}\\\\\n"
		elsif(@type == "frame")
			chaine = "\\begin{frame}\n\\frametitle{#{@value}}\n"
		elsif(@type == "endframe")
			chaine = "\\end{frame}\n"
		elsif(@type == "endblock")
			chaine = "\\end{block}\n"
		end
		
		return chaine
	end
end
