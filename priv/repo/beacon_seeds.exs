# Script for populating sites data. You can run it as:
#
#     mix run priv/repo/beacon_seeds.exs

alias Beacon.Components
alias Beacon.Pages
alias Beacon.Layouts
alias Beacon.Stylesheets

Stylesheets.create_stylesheet!(%{
  site: "demo",
  name: "sample_stylesheet",
  content: "body {cursor: zoom-in;}"
})

Stylesheets.create_stylesheet!(%{
  site: "blog",
  name: "sample_stylesheet",
  content: "body {cursor: zoom-in;}"
})

Components.create_component!(%{
  site: "demo",
  name: "sample_component",
  body: """
  <li>
    <%= @val %>
  </li>
  """
})

%{id: demo_layout_id} =
  Layouts.create_layout!(%{
    site: "demo",
    title: "Sample Home Page",
    meta_tags: %{"foo" => "bar"},
    stylesheet_urls: [],
    body: """
    <header>
      <p class="text-2xl">Header</p>
    </header>
    <%= @inner_content %>

    <footer>
      Page Footer
    </footer>
    """
  })

%{id: page_id} =
  Pages.create_page!(%{
    path: "home",
    site: "demo",
    layout_id: demo_layout_id,
    template: """
    <main>
      <h2>Some Values:</h2>
      <ul>
        <%= for val <- @beacon_live_data[:vals] do %>
          <%= my_component("sample_component", val: val) %>
        <% end %>
      </ul>

      <.form let={f} for={:greeting} phx-submit="hello">
        Name: <%= text_input f, :name %> <%= submit "Hello" %>
      </.form>

      <%= if assigns[:message], do: assigns.message %>

      <%= dynamic_helper("upcase", "Beacon") %>
    </main>
    """
  })

Pages.create_page_event!(%{
  page_id: page_id,
  event_name: "hello",
  code: """
    {:noreply, assign(socket, :message, "Hello \#{event_params["greeting"]["name"]}!")}
  """
})

Pages.create_page_helper!(%{
  page_id: page_id,
  helper_name: "upcase",
  helper_args: "name",
  code: """
    String.upcase(name)
  """
})

%{id: blog_layout_id} =
  Layouts.create_layout!(%{
    site: "blog",
    title: "Sample Blog",
    meta_tags: %{"foo" => "bar"},
    stylesheet_urls: [],
    body: """
    <header>
      <p class="text-2xl">Header</p>
    </header>
    <%= @inner_content %>

    <footer>
      Page Footer
    </footer>
    """
  })

Pages.create_page!(%{
  path: "posts/:post_slug",
  site: "blog",
  layout_id: blog_layout_id,
  template: """
  <main>
    <h2>A blog</h2>
    <ul>
      <li>Path Params Blog Slug: <%= @beacon_path_params.post_slug %></li>
      <li>Live Data post_slug_uppercase: <%= @beacon_live_data.post_slug_uppercase %></li>
    </ul>
  </main>
  """
})
