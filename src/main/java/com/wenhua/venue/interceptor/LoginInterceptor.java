package com.wenhua.venue.interceptor;

import com.wenhua.venue.entity.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录拦截器：拦截 /admin/**、/my/**、预约和评价请求
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
                             Object handler) throws Exception {
        HttpSession session = request.getSession();
        User loginUser = (User) session.getAttribute("loginUser");

        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect="
                    + java.net.URLEncoder.encode(request.getRequestURI(), "UTF-8"));
            return false;
        }

        // 管理端请求需要 ADMIN 角色
        String uri = request.getRequestURI();
        if (uri.contains("/admin/") && !"ADMIN".equals(loginUser.getRole())) {
            response.sendError(403, "无权限访问管理后台");
            return false;
        }
        return true;
    }
}
