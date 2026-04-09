require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "default role is user" do
    user = User.new(email: "new@example.com", password: "password123")
    assert user.user?
    refute user.admin?
  end

  test "admin role assignment from fixture" do
    user = users(:admin_user)
    assert user.admin?
    refute user.user?
  end

  test "admins scope returns only admins" do
    result = User.admins
    assert_includes result, users(:admin_user)
    refute_includes result, users(:regular_user)
  end

  test "regular_users scope excludes admins" do
    result = User.regular_users
    assert_includes result, users(:regular_user)
    refute_includes result, users(:admin_user)
  end

  test "email uniqueness validation" do
    duplicate = User.new(
      email: users(:regular_user).email,
      password: "password123"
    )
    refute duplicate.valid?
    assert duplicate.errors[:email].any?
  end

  test "password required for new user" do
    user = User.new(email: "nopass@example.com")
    refute user.valid?
    assert user.errors[:password].any?
  end
end
