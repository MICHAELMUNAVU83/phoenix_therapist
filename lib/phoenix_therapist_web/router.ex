defmodule PhoenixTherapistWeb.Router do
  use PhoenixTherapistWeb, :router

  import PhoenixTherapistWeb.UserAuth

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PhoenixTherapistWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", PhoenixTherapistWeb do
    pipe_through(:browser)

    live("/", PageLive.Index, :index)
  end

  scope "/", PhoenixTherapistWeb do
    pipe_through([:browser, :require_authenticated_user])

    live("/bookings", BookingLive.Index, :index)
    live("/bookings/new", BookingLive.Index, :new)
    live("/bookings/:id/edit", BookingLive.Index, :edit)

    live("/bookings/:id", BookingLive.Show, :show)

    live("/bookings/:id/show/edit", BookingLive.Show, :edit)

    live("/notes", NoteLive.Index, :index)
    live("/notes/new", NoteLive.Index, :new)
    live("/notes/:id/edit", NoteLive.Index, :edit)

    live("/notes/:id", NoteLive.Show, :show)
    live("/notes/:id/show/edit", NoteLive.Show, :edit)
  end

  scope "/", PhoenixTherapistWeb do
    pipe_through([:browser, :require_admin])

    live("/available_times", AvailableTimeLive.Index, :index)
    live("/available_times/new", AvailableTimeLive.Index, :new)
    live("/available_times/:id/edit", AvailableTimeLive.Index, :edit)

    live("/available_times/:id", AvailableTimeLive.Show, :show)
    live("/available_times/:id/show/edit", AvailableTimeLive.Show, :edit)
    live("/doctor_bookings", DoctorBookingLive.Index, :index)
    live("/doctor_bookings/:id", DoctorBookingLive.Show, :show)
    live("/doctor_bookings/:id/addnotes", DoctorBookingLive.Show, :addnotes)
    live("/doctor_bookings/:id/notes/:note_id", DoctorBookingLive.Show, :editnote)
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixTherapistWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: PhoenixTherapistWeb.Telemetry)
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end

  ## Authentication routes

  scope "/", PhoenixTherapistWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/users/register", UserRegistrationController, :new)
    post("/users/register", UserRegistrationController, :create)
    get("/users/log_in", UserSessionController, :new)
    post("/users/log_in", UserSessionController, :create)
    get("/users/reset_password", UserResetPasswordController, :new)
    post("/users/reset_password", UserResetPasswordController, :create)
    get("/users/reset_password/:token", UserResetPasswordController, :edit)
    put("/users/reset_password/:token", UserResetPasswordController, :update)
  end

  scope "/", PhoenixTherapistWeb do
    pipe_through([:browser, :require_authenticated_user])

    get("/users/settings", UserSettingsController, :edit)
    put("/users/settings", UserSettingsController, :update)
    get("/users/settings/confirm_email/:token", UserSettingsController, :confirm_email)
  end

  scope "/", PhoenixTherapistWeb do
    pipe_through([:browser])

    delete("/users/log_out", UserSessionController, :delete)
    get("/users/confirm", UserConfirmationController, :new)
    post("/users/confirm", UserConfirmationController, :create)
    get("/users/confirm/:token", UserConfirmationController, :edit)
    post("/users/confirm/:token", UserConfirmationController, :update)
  end
end
