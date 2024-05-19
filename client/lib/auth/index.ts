"use server";

import { cookies } from "next/headers";
import { redirect } from "next/navigation";
import { revalidatePath } from "next/cache";
import { NextRequest, NextResponse } from "next/server";
import { getIronSession, IronSession, SessionOptions } from "iron-session";

interface SessionData {
  userId?: number;
  username?: string;
  isBlocked?: boolean;
  token: string;
  refreshToken: string;
  email: string;
  email_verified: boolean;
  name: string;
  picture: string;
}

const cookieOptions = {
  httpOnly: true,
  secure: process.env.NODE_ENV === "production",
};

const sessionOptions: SessionOptions = {
  password: process.env.SECRET_KEY,
  cookieOptions,
  cookieName: "user-session",
};

const activeSessionKey = "session";

const updateActiveSession = (response?: NextResponse) => {
  if (response) {
    response.cookies.set(activeSessionKey, "active", { maxAge: 100 });
    return;
  }

  cookies().set(activeSessionKey, "active", { maxAge: 100 });
};

const deleteActiveSession = () => {
  cookies().delete(activeSessionKey);
};

const isSessionActive = (request?: NextRequest) => {
  if (request) return request.cookies.has(activeSessionKey);
  return cookies().has(activeSessionKey);
};

const getSession = async (request?: NextRequest, response?: NextResponse) => {
  if (request && response)
    return await getIronSession<SessionData>(request, response, sessionOptions);

  return await getIronSession<SessionData>(cookies(), sessionOptions);
};

const refreshToken = async (session: SessionData) => {
  // REFRESH TOKEN -> UPDATE SESSION -> SAVE SESSION -> RETURN NEW SESSION
  return session as IronSession<SessionData>;
};

const getServerSession = async (path = "/login") => {
  const session = await getSession();

  if (!session.userId) redirect(path);
  if (isSessionActive()) return session;

  try {
    return await refreshToken(session);
  } catch (err) {
    redirect(path);
  }
};

const login = async (
  { error, callbackUrl }: { error: undefined | string; callbackUrl: string },
  formData: FormData
) => {
  const session = await getSession();

  const formUsername = formData.get("username") as string;

  // CHECK USER IN THE DB

  if (formUsername !== "vanit") {
    return { error: "Wrong Credentials!", callbackUrl };
  }

  updateActiveSession();

  session.userId = 1;
  session.token = "32479236978dkbkfshdjkl2789369dkjfhsd=";
  session.name = formUsername;

  await session.save();

  redirect(callbackUrl || "/dashboard");
};

const logout = async (formData: unknown, path = "/login") => {
  deleteActiveSession();
  const session = await getSession();

  session.destroy();

  redirect(path);
};

const changeUsername = async (formData: FormData, path = "/profile") => {
  const session = await getSession();

  const newUsername = formData.get("username") as string;

  session.username = newUsername;

  await session.save();

  revalidatePath(path);
};

export {
  login,
  logout,
  getSession,
  refreshToken,
  changeUsername,
  isSessionActive,
  getServerSession,
  updateActiveSession,
  deleteActiveSession,
};
