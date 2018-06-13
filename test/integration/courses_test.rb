require 'test_helper'

class CoursesTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:yannick)
    @other_user = users(:foobar)
  end

  test "index page when logged in as admin" do
    log_in_as(@user)
    get courses_path
    assert_select 'div.card-body' do
      assert_select 'form', count: Course.count
      assert_select 'a[data-method="delete"]', count: Course.count
    end
    assert_select "a[href=?]", new_course_path
  end

  test "index page when logged in" do
    log_in_as(@other_user)
    get courses_path
    assert_select 'div.card-body' do
      assert_select 'form', count: Course.count
      assert_select 'a[data-method="delete"]', count: 0
    end
    assert_select "a[href=?]", new_course_path, count: 0
  end

  test "invalid new courses" do
    log_in_as(@user)
    get new_course_path
    assert_select 'form[action="/courses"]'
    assert_no_difference 'Course.count' do
      post courses_path, params: { course: { name: "",
                                             description: "" } }
    end
    assert_template 'courses/new'
    assert_select "div#error_explanation"
    assert_select "div.alert"
  end

  test "valid new courses" do
    log_in_as(@user)
    get new_course_path
    assert_select 'form[action="/courses"]'
    assert_difference 'Course.count' do
      post courses_path, params: { course: { name: "Foobar",
                                             description: "Lorem ipsum...",
                                             group_id: Group.first.id } }
    end
    follow_redirect!
    assert_template 'courses/index'
    assert_not flash.empty?
    assert_select "div.alert-success"
  end
end
