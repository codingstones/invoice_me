module PageObjects
  class Page
    def initialize(context)
      @context = context
    end
  end

  class LoginPage < Page
    def initialize(context)
      super(context)
      @context.page.reset!
      @context.visit '/login'
    end

    def authenticate(user, password)
      @context.within("form") do
        @context.fill_in 'user', with: user
        @context.fill_in 'password', with: password
      end
      @context.click_button 'Entrar'

      if logged_out?
        self
      else
        AuthenticatedPage.new(@context)
      end
    end

    def logged_out?
      @context.page.first(:css, 'h1').text == 'Entra a registrar tus facturas'
    end
  end

  class AuthenticatedPage < Page
    def initialize(context)
      super(context)

      unless logged_in?
        raise 'The user is not authenticated. Authenticated menu navegation is not found'
      end
    end

    def logged_in?
      @context.page.first(:css, '.page-menu') != nil
    end

    def logout
      @context.click_link 'Salir'
      LoginPage.new(@context)
    end
  end

  class ProviderInvoicesPage < AuthenticatedPage
    def initialize(context)
      super(context)
      @context.visit '/'
    end

    def has_invoices?
      @context.page.first(:css, '.invoices-list li') != nil
    end
  end

  class RegisterInvoicePage < AuthenticatedPage
    def initialize(context)
      super(context)
      @context.visit '/new'
    end

    def register(args)
      @context.within("form") do
        @context.fill_in 'document_number', with: args[:document_number]
        @context.fill_in 'date', with: args[:date] if args[:date]
        @context.fill_in 'description[]', with: args[:lines].first[:description]
        @context.fill_in 'base[]', with: args[:lines].first[:base]
        @context.fill_in 'vat[]', with: args[:lines].first[:vat]
        @context.fill_in 'retention[]', with: args[:lines].first[:retention]
      end
      @context.click_button 'Registrar factura'

      ProviderInvoicesPage.new(@context) unless errors?
    end

    def errors?
      @context.page.first(:css, 'div.errors') != nil
    end
  end
end
