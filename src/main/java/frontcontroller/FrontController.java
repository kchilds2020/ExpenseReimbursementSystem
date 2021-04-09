package frontcontroller;

import controllers.UserController;
import dao.ProductionConfig;
import io.javalin.Javalin;
import models.User;
import services.UserService;
import services.UserServiceImpl;

import static io.javalin.apibuilder.ApiBuilder.*;
import static io.javalin.apibuilder.ApiBuilder.put;

/**
 * Location of all middleware
 * */
public class FrontController {
    Javalin app;
    Dispatcher dispatcher;
    UserService userService = new UserServiceImpl(ProductionConfig.url, ProductionConfig.username, ProductionConfig.password);

    public FrontController(Javalin app) {
        this.app = app;

        this.app.before("/employee/*",context -> {
            User user = context.sessionAttribute("killua");
            System.out.println("SESSION: " + user);
            if(user == null)
                context.redirect("/");
            else if(user.getRole().getId() == 2)
                context.redirect("/financemanager/dashboard");
        });

        this.app.before("/financemanager/*",context -> {
            User user = context.sessionAttribute("killua");
            System.out.println("SESSION: " + user);
            if(user == null)
                context.redirect("/");
            else if(user.getRole().getId() == 1)
                context.redirect("/employee/dashboard");
        });

        app.before("/api/*", context -> {
           User user = context.sessionAttribute("killua");
           if(user == null){
               context.redirect("/womp-womp");
           }
        });

        this.dispatcher = new Dispatcher(app);
    }
}
