defmodule InBeautyWeb.PerfumeLiveTest do
  use InBeautyWeb.ConnCase

  import Phoenix.LiveViewTest

  import InBeautyWeb.Factory, only: [insert: 1, params_for: 1]

  @create_attrs %{
    description: "some description",
    gender: "some gender",
    manufacturer: "some manufacturer",
    name: "some name"
  }
  @update_attrs %{
    description: "some updated description",
    gender: "some updated gender",
    manufacturer: "some updated manufacturer",
    name: "some updated name"
  }
  @invalid_attrs %{description: nil, gender: nil, manufacturer: nil, name: nil}

  setup do
    {:ok, %{perfume: insert(:perfume)}}
  end

  describe "Index" do
    test "lists all perfumes", %{conn: conn, perfume: perfume} do
      {:ok, _index_live, html} = live(conn, Routes.perfume_index_path(conn, :index))

      assert html =~ "Listing Perfumes"
      assert html =~ "page_1"
    end
  end

  describe "Show" do
    test "displays perfume", %{conn: conn, perfume: perfume} do
      {:ok, _show_live, html} = live(conn, Routes.perfume_show_path(conn, :show, perfume))

      assert html =~ "Show Perfume"
      assert html =~ perfume.description
    end

    test "don't updates perfume within modal", %{conn: conn, perfume: perfume} do
      {:ok, show_live, _html} = live(conn, Routes.perfume_show_path(conn, :show, perfume))

      assert {:error, {:redirect, %{to: _}}} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, Routes.perfume_show_path(conn, :edit, perfume))

      assert_patch(show_live, Routes.perfume_show_path(conn, :edit, perfume))

      assert show_live
             |> form("#perfume-form", perfume: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"
    end
  end
end
