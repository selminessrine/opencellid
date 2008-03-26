require File.dirname(__FILE__) + '/../test_helper'
require 'cells_controller'

# Re-raise errors caught by the controller.
class CellsController; def rescue_action(e) raise e end; end

class CellsControllerTest < Test::Unit::TestCase
  fixtures :cells

  def setup
    @controller = CellsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = cells(:first).id
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

    assert_not_nil assigns(:cells)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:cell)
    assert assigns(:cell).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:cell)
  end

  def test_create
    num_cells = Cell.count

    post :create, :cell => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_cells + 1, Cell.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:cell)
    assert assigns(:cell).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Cell.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Cell.find(@first_id)
    }
  end
end
