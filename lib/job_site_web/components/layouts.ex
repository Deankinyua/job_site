defmodule JobSiteWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use JobSiteWeb, :html

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :active_tab, :atom,
    default: :home,
    values: [
      :applications,
      :jobs,
      :home
    ]

  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <div class="min-h-screen bg-slate-50 md:flex">
      <aside
        id="app-sidebar"
        class="border-b border-slate-200 bg-white p-4 md:sticky md:top-0 md:h-screen md:w-64 md:shrink-0 md:border-r md:border-b-0 md:p-6"
      >
        <p class="mb-6 px-3 text-lg font-semibold tracking-tight text-slate-900">Job Site</p>
        <nav aria-label="Main navigation" class="space-y-2">
          <div>
            <.link
              id="sidebar-home"
              navigate={~p"/admin/home"}
              aria-current={if @active_tab == :home, do: "page"}
              class={[
                "flex items-center gap-3 rounded-xl px-3 py-3 text-sm font-medium transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-500",
                @active_tab == :home && "bg-slate-900 text-white",
                @active_tab != :home && "text-slate-600 hover:bg-slate-100 hover:text-slate-900"
              ]}
            >
              <.icon name="hero-home" class="size-5 shrink-0" /> Home
            </.link>
          </div>
          <div>
            <.link
              id="sidebar-applications"
              navigate={~p"/admin/applications"}
              aria-current={if @active_tab == :applications, do: "page"}
              class={[
                "flex items-center gap-3 rounded-xl px-3 py-3 text-sm font-medium transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-500",
                @active_tab == :applications && "bg-slate-900 text-white",
                @active_tab != :applications &&
                  "text-slate-600 hover:bg-slate-100 hover:text-slate-900"
              ]}
            >
              <.icon name="hero-document-text" class="size-5 shrink-0" /> Job Applications
            </.link>
          </div>
          <div>
            <.link
              id="sidebar-jobs"
              navigate={~p"/admin/jobs"}
              aria-current={if @active_tab == :jobs, do: "page"}
              class={[
                "flex items-center gap-3 rounded-xl px-3 py-3 text-sm font-medium transition-colors focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-slate-500",
                @active_tab == :jobs && "bg-slate-900 text-white",
                @active_tab != :jobs && "text-slate-600 hover:bg-slate-100 hover:text-slate-900"
              ]}
            >
              <.icon name="hero-briefcase" class="size-5 shrink-0" /> Job Vacancies
            </.link>
          </div>
        </nav>
      </aside>

      <main class="min-w-0 flex-1 px-4 py-10 sm:px-6 lg:px-8">
        <div class="mx-auto max-w-2xl space-y-4">
          {render_slot(@inner_block)}
        </div>
      </main>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end
end
