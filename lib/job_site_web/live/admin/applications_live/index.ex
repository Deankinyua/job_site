defmodule JobSiteWeb.Admin.ApplicationsLive.Index do
  use JobSiteWeb, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <Layouts.app
      flash={@flash}
      active_tab={:applications}
    >
      <section
        id="applications"
        aria-labelledby="title"
        class="flex min-h-[65vh] items-center justify-center py-8"
      >
        <h1
          id="applications-title"
          class="rounded-xl border border-slate-200 px-10 py-8 text-center text-3xl font-semibold tracking-tight text-slate-900"
        >
          Coming Soon
        </h1>
      </section>
    </Layouts.app>
    """
  end
end
