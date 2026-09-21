package com.wenhua.venue.utils;

import lombok.Data;

/**
 * 统一 AJAX 返回结果
 */
@Data
public class Result<T> {
    private boolean success;
    private String message;
    private T data;

    public static <T> Result<T> ok(String message) {
        return ok(message, null);
    }

    public static <T> Result<T> ok(String message, T data) {
        Result<T> r = new Result<>();
        r.setSuccess(true);
        r.setMessage(message);
        r.setData(data);
        return r;
    }

    public static <T> Result<T> fail(String message) {
        Result<T> r = new Result<>();
        r.setSuccess(false);
        r.setMessage(message);
        return r;
    }
}
