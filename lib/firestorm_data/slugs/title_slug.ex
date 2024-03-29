defmodule FirestormData.Slugs.TitleSlug do
  @moduledoc """
  Module that makes it easy to create title slugs that autogenerate unique
  titles.
  """

  defmacro __using__(module) do
    quote do
      use EctoAutoslugField.Slug, from: :title, to: :slug
      alias FirestormData.Repo
      import Ecto.Query

      def build_slug(sources) do
        base_slug =
          sources
          |> super()
          |> strip_for_db()

        get_unused_slug(base_slug, 0)
      end

      def get_unused_slug(base_slug, number) do
        slug = get_slug(base_slug, number)

        if slug_used?(slug) do
          get_unused_slug(base_slug, number + 1)
        else
          slug
        end
      end

      def slug_used?(slug) do
        unquote(module)
        |> where(slug: ^slug)
        |> Repo.one()
      end

      def get_slug(base_slug, 0), do: base_slug

      def get_slug(base_slug, number) do
        "#{base_slug}-#{number}"
      end

      defp strip_for_db(maybe_not_utf) do
        for <<char::8 <- maybe_not_utf>>, char > 32, char < 122 do
          char
        end
        |> to_string()
      end
    end
  end
end
