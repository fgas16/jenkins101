import pytest
from calculator import add, subtract, multiply, divide

def test_add():
    assert add(3, 4) == 7
    assert add(-2, 5) == 3

def test_subtract():
    assert subtract(10, 4) == 6
    assert subtract(4, 10) == -6

def test_multiply():
    assert multiply(3, 5) == 15
    assert multiply(-2, 3) == -6

def test_divide():
    assert divide(10, 2) == 5
    assert divide(7, 2) == 3.5

def test_divide_by_zero():
    with pytest.raises(ValueError, match="Cannot divide by zero."):
        divide(5, 0)
