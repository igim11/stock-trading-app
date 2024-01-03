require "test_helper"


class AdminTest < ActiveSupport::TestCase
  test "should not save admin without first_name" do
    admin = Admin.new
    assert_not admin.save, "Saved the admin without a first_name"
  end

  test "should not save admin without last_name" do
    admin = Admin.new
    assert_not admin.save, "Saved the admin without a last_name"
  end

  test "should not save admin without user_id" do
    admin = Admin.new
    assert_not admin.save, "Saved the admin without a user_id"
  end

  test "should not save admin without email" do
    admin = Admin.new(first_name: "Christine" , last_name: "Tauy")
    assert_not admin.save, "Saved the admin without an email"
  end

  test "should not save admin without password" do
    admin = Admin.new(first_name: "Christine" , last_name: "Tauy", user_id: "test" email: "test_email@example.com")
    assert_not admin.save, "Saved the admin without a password"
  end




end
