defmodule ApiMonitor.BillingsTest do
  use ApiMonitor.DataCase

  alias ApiMonitor.Billings

  describe "invoices" do
    alias ApiMonitor.Billings.Invoice

    import ApiMonitor.BillingsFixtures

    @invalid_attrs %{}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Billings.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Billings.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{}

      assert {:ok, %Invoice{} = invoice} = Billings.create_invoice(valid_attrs)
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Billings.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      update_attrs = %{}

      assert {:ok, %Invoice{} = invoice} = Billings.update_invoice(invoice, update_attrs)
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Billings.update_invoice(invoice, @invalid_attrs)
      assert invoice == Billings.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Billings.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Billings.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Billings.change_invoice(invoice)
    end
  end
end
