import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import {
  getSession,
  isSessionActive,
  refreshToken,
  updateActiveSession,
} from "@/lib/auth";

export async function middleware(request: NextRequest) {
  const response = NextResponse.next();

  const session = await getSession(request, response);

  if (isSessionActive(request) && session?.token) {
    updateActiveSession(response);
    return response;
  }

  try {
    const upSession = await refreshToken(session);
    if (!upSession?.token) throw new Error("Session Expired");
    return response;
  } catch (err) {
    return NextResponse.redirect(
      new URL(`?callbackUrl=${request.nextUrl.href}`, request.nextUrl.origin)
    );
  }
}

export const config = {
  matcher: ["/dashboard"],
};
