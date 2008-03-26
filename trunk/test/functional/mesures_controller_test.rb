require File.dirname(__FILE__) + '/../test_helper'
require 'mesures_controller'

# Re-raise errors caught by the controller.
class MesuresController; def rescue_action(e) raise e end; end

class MesuresControllerTest < Test::Unit::TestCase
  fixtures :mesures

  def setup
    @controller = MesuresController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = mesures(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:mesures)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:mesure)
    assert assigns(:mesure).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:mesure)
  end

  def test_create
    num_mesures = Mesure.count

    post :create, :mesure => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_mesures + 1, Mesure.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:mesure)
    assert assigns(:mesure).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Mesure.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Mesure.find(@first_id)
    }
  end
end
