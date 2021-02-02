package main

import (
	"fmt"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestMain(m *testing.M) {
	fmt.Println("测试开始")
	m.Run()
	fmt.Println("测试结束")
}

func TestPingRoute(t *testing.T) {
	router := setupRouter()
	t.Run("/abc is 404", func(t *testing.T) {
		response := httptest.NewRecorder()
		request, _ := http.NewRequest("GET", "/abc", nil)
		router.ServeHTTP(response, request)
		assert.Equal(t, 404, response.Code)
	})

	t.Run("/ping response pong", func(t *testing.T) {
		response := httptest.NewRecorder()
		request, _ := http.NewRequest("GET", "/ping", nil)
		router.ServeHTTP(response, request)
		assert.Equal(t, 200, response.Code)
		assert.JSONEq(t, `{"message":"pong"}`, response.Body.String())
	})
}
