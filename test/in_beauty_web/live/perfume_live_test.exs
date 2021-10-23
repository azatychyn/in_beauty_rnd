defmodule InBeautyWeb.PerfumeLiveTest do
  use InBeautyWeb.ConnCase

  import Phoenix.LiveViewTest
  import InBeauty.CatalogueFixtures

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

  defp create_perfume(_) do
    perfume = perfume_fixture()
    %{perfume: perfume}
  end

  describe "Index" do
    setup [:create_perfume]

    test "lists all perfumes", %{conn: conn, perfume: perfume} do
      {:ok, _index_live, html} = live(conn, Routes.perfume_index_path(conn, :index))

      assert html =~ "Listing Perfumes"
      assert html =~ perfume.description
    end

    test "saves new perfume", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.perfume_index_path(conn, :index))

      assert index_live |> element("a", "New Perfume") |> render_click() =~
               "New Perfume"

      assert_patch(index_live, Routes.perfume_index_path(conn, :new))

      assert index_live
             |> form("#perfume-form", perfume: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#perfume-form", perfume: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.perfume_index_path(conn, :index))

      assert html =~ "Perfume created successfully"
      assert html =~ "some description"
    end

    test "updates perfume in listing", %{conn: conn, perfume: perfume} do
      {:ok, index_live, _html} = live(conn, Routes.perfume_index_path(conn, :index))

      assert index_live |> element("#perfume-#{perfume.id} a", "Edit") |> render_click() =~
               "Edit Perfume"

      assert_patch(index_live, Routes.perfume_index_path(conn, :edit, perfume))

      assert index_live
             |> form("#perfume-form", perfume: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#perfume-form", perfume: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.perfume_index_path(conn, :index))

      assert html =~ "Perfume updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes perfume in listing", %{conn: conn, perfume: perfume} do
      {:ok, index_live, _html} = live(conn, Routes.perfume_index_path(conn, :index))

      assert index_live |> element("#perfume-#{perfume.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#perfume-#{perfume.id}")
    end
  end

  describe "Show" do
    setup [:create_perfume]

    test "displays perfume", %{conn: conn, perfume: perfume} do
      {:ok, _show_live, html} = live(conn, Routes.perfume_show_path(conn, :show, perfume))

      assert html =~ "Show Perfume"
      assert html =~ perfume.description
    end

    test "updates perfume within modal", %{conn: conn, perfume: perfume} do
      {:ok, show_live, _html} = live(conn, Routes.perfume_show_path(conn, :show, perfume))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Perfume"

      assert_patch(show_live, Routes.perfume_show_path(conn, :edit, perfume))

      assert show_live
             |> form("#perfume-form", perfume: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#perfume-form", perfume: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.perfume_show_path(conn, :show, perfume))

      assert html =~ "Perfume updated successfully"
      assert html =~ "some updated description"
    end
  end
end
