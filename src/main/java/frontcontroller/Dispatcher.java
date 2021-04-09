package frontcontroller;

import controllers.ReimbursementController;
import controllers.UserController;
import io.javalin.Javalin;

import static io.javalin.apibuilder.ApiBuilder.*;


/**
 * distributes all routes
 * */
public class Dispatcher {
    UserController userController = new UserController();
    ReimbursementController reimbursementController = new ReimbursementController();

    public Dispatcher(Javalin app) {
        app.routes(() -> {
            path("womp-womp", ()->{
                get(context -> {
                    context.result("unauthorized");
                });
            });
            path("login", () -> {
                post(userController::loginUser);
            });
            path("feedback", () -> {
                get(userController::getFeedback);
            });
            path("api", ()->{
                path("get",() ->{
                    path("users",() -> {
                        get(userController::getAllUsers);
                        path("check-session", () -> {
                            get(userController::checkSession);
                        });
                        path("logout", () -> {
                            get(userController::logout);
                        });
                        path(":username", () -> {
                            get(userController::getOneUser);
                        });
                    });
                    path("reimbursements",() ->{
                        get(reimbursementController::getAllReimbursements);

                        path(":username", () -> {
                            get(reimbursementController::getAllReimbursementsGivenUser);
                        });

                        path("id/:id", () -> {
                            get(reimbursementController::getOneReimbursement);
                        });

                    });
                });
                path("post", () ->{
                    path("users",() ->{

                        path("register", () -> {
                            post(userController::registerUser);
                        });
                    });
                    path("reimbursements",() ->{
                        path("create", () -> {
                            post(reimbursementController::createReimbursement);
                        });
                    });
                });
                path("put", () -> {
                    path("reimbursements",() ->{
                        path("approve/:resid/:reimbid", () -> {
                            put(reimbursementController::approveReimbursement);
                        });
                        path("deny/:resid/:reimbid", () -> {
                            put(reimbursementController::denyReimbursement);
                        });
                    });
                });
            });
        });
    }
}
