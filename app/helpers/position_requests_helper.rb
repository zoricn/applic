module PositionRequestsHelper
	def request_mail_signature(request)
		"CEO, Kolosek IT<br />
		Bulevar Oslobodjenja 11-13, Novi Sad, Serbia<br />
		www.kolosek.com".html_safe
	end
end
