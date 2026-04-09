require "test_helper"

class LocaleControllerTest < ActionDispatch::IntegrationTest
  test "switch to valid locale fr sets session" do
    get switch_locale_url(locale: "fr")
    assert_equal "fr", session[:locale]
    assert_response :redirect
  end

  test "switch to valid locale en sets session" do
    get switch_locale_url(locale: "en")
    assert_equal "en", session[:locale]
    assert_response :redirect
  end

  test "switch to invalid locale does not set session" do
    get switch_locale_url(locale: "xx")
    assert_nil session[:locale]
    assert_response :redirect
  end

  test "redirects back to referer when available" do
    get switch_locale_url(locale: "fr"),
      headers: { "HTTP_REFERER" => "http://www.example.com/" }
    assert_redirected_to "http://www.example.com/"
  end

  test "falls back to root when no referer" do
    get switch_locale_url(locale: "fr")
    assert_redirected_to root_url
  end
end
